#!/usr/bin/env node
const bent = require("bent");
const getBody = bent("string");
const cheerio = require("cheerio");
const Fuse = require("fuse.js");
const fs = require("fs");
const url = require("./url.json");
const { program } = require("commander");

class RequestError extends Error {}

let matchCount = 0;
let pageCount = 0;
async function incrCounts(incr) {
   pageCount += 1;
   matchCount += incr;
   process.stdout.write(`\r${pageCount} pages searched. Matches found: ${matchCount}`);
}

function getTitles($) {
   let titlesRows = [];

   titlesRows = Array.from($(".topic_title"));
   if(titlesRows.length > 0) {
      return titlesRows.map((ele) => {
         const link = ele.attribs["href"];
         const titleSpan = $(ele).find("span");
         if(titleSpan.length > 0){
            const title = titleSpan[0].firstChild.nodeValue;
            return {link, title};
         } else {
            return {link: null, title: null};
         }
      });
   }
   //fallback for english movie forumns
   titlesRows = Array.from($(".article_title"));
   if(titlesRows.length > 0) {
      return titlesRows.map((ele) => {
         const link = ele.attribs["href"];
         if(ele.childNodes.length > 0){
            const title = ele.firstChild.data;
            return {link, title};
         } else {
            return {link: null, title: null};
         }
      });
   }
   return [];
}


function getMatches($, searchString) {
   const titles = getTitles($);
   let matches = [];

   if (titles.length > 0) {
      const fuse = new Fuse(titles, {keys: ["title"], threshold: 0.3});
      matches = fuse.search(searchString).map((ele) => ele.item);
   }
   return matches;
}

async function getPage(url) {

   const nextNewSelector = ".topic_controls .next a";
   const nextOldSelector = ".next";
   let htmlBody = null;

   try {
      htmlBody = await getBody(url);
   } catch (error) {
      throw new RequestError(error);
   }
   const $ = cheerio.load(htmlBody);

   var nextPage = null;
   if ($(nextNewSelector).length > 0) {
      nextPage = $(nextNewSelector)[0].attribs["href"];
   } 
   else if($(nextOldSelector).length > 0) {
      nextPage = $(nextOldSelector)[0].attribs["href"];
   }
   return {$, nextPage};
}

async function searchForum(url, searchString) {

   const matchedTitles = new Array();
   let nextPage = url;
   //repeatedly scrape each page and find the matches
   while(nextPage !== null) {
      try {
         const res = await getPage(nextPage);
         nextPage = res.nextPage;
         const matches = getMatches(res.$, searchString);
         incrCounts(matches.length);
         matchedTitles.push(...matches);
      } catch (error) {
         continue;
      }
   }
   return matchedTitles;
}

async function main(args){
   
   const {language, searchString, output} = args;
   //language validation
   let forumUrls;
   if (language.toLowerCase() === "all") {
      forumUrls = Object.keys(url).map((lang) => url[lang]).reduce((cur, next) => cur.concat(next));
   } else {
      forumUrls = url[language.toLowerCase()];
      if(!forumUrls) {
         console.log("Input Language not supported. Exiting...");
         process.exit(1);
      }
   }
   //checking connection
   try {
      await getPage(forumUrls[0]);
   } catch (error) {
      console.log("Connection Failed. TamilRockers might be blocked in your region!");
      process.exit(1);
   }
   //create all the async functions and store the results
   const functions = forumUrls.map((url) => searchForum(url, searchString));
   Promise.all(functions).then((results) => {
      const matchedTitles = results.reduce((cur, next) => cur.concat(next));
      if (matchedTitles.length === 0){
         console.log("\nNo matches found."); return;
      }
      const fileOutputs = matchedTitles.map((ele) => ele.link).join("\n");
      fs.writeFileSync(output, fileOutputs);
      console.log(`\nResults stored to ${output}`);
   });
}

program
   .requiredOption("-l, --language <type>", "Movie Language")
   .requiredOption("-s, --searchString <type>", "Search String/Movie Name")
   .requiredOption("-o, --output <type>", "Output File Name");
program.parse(process.argv);

main(program);
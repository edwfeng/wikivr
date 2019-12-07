const puppeteer = require("puppeteer");

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    const url = process.argv[2];
    await page.goto(url);
    await page.setViewport({
  	    height: $("body").height,
  	    width: process.argv[3]
    });
    await page.screenshot({path: "output.png", fullPage: true});
  
    await browser.close();
})();

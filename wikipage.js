const puppeteer = require("puppeteer");
const fs = require("fs");
const path = require("path");

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    const url = process.argv[2];

    console.log("Started browser.");

    page.setJavaScriptEnabled(false);

    await page.goto(url);

    console.log("Fetched page.");

    let width = parseInt(process.argv[3]);
    await page.setViewport({
        height: 1000,
        width
    });

    console.log("Set viewport.");

    await Promise.all(["#mw-page-base", "#frb-inline", "#mw-head-base", "#mw-data-after-content", "#mw-navigation", "#footer", "#mwe-popups-svg", "#toc", "#siteNote"].map(async sel => {
        let handle = await page.$(sel);
        if (handle) {
            await handle.evaluate(el => el.remove());
            console.log("Removed " + sel)
        }
    }));

    (await page.$("#content")).evaluate(el => {
        el.style.margin = 0;
        el.style.border = 0;
    });

    console.log("Adjusted styles.");

    let height = await (await page.$("body")).evaluate(el => el.scrollHeight);
    console.log(height);

    console.log("Determined height.");

    await page.setViewport({
        height: Math.min(height, 16384),
        width
    });
    
    console.log("Set viewport again.");

    await page.screenshot({path: "output.png"});

    let links = await Promise.all((await page.$$('a[href^="/wiki/"]')).map(handle => handle.evaluate(a =>
        ({name: decodeURIComponent(a.getAttribute("href").slice(6).replace(/_/g, " ")), y: a.getBoundingClientRect().top}))));
    
    let filtered = links.filter(s => !s.name.includes(":")).filter(s => !s.name.includes("(disambiguation")).filter(s => s.y > 0);

    let final = [];
    let seen = {};
    filtered.forEach(link => {
        if (!seen[link.name]) {
            seen[link.name] = true;
            final.push(link);
        }
    });

    fs.writeFileSync(path.join(__dirname, "output.json"), JSON.stringify(final.sort((a, b) => a.y - b.y)), "utf8");
    
    console.log("Scraped links.")

    console.log("Took screenshot.")
  
    await browser.close();
})().then(() => process.exit(0)).catch(e => {console.log(e.stack); process.exit(1)});

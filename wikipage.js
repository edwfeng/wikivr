const puppeteer = require("puppeteer");

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

    console.log("Took screenshot.")
  
    await browser.close();
})().then(() => process.exit(0)).catch(e => {console.log(e.stack); process.exit(1)});

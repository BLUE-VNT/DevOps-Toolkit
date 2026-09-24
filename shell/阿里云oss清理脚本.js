(async () => {
    const target =
        "https://oss.console.aliyun.com/bucket/oss-cn-zhangjiakou/fenqi-shop/object";

    if (!location.href.startsWith(target)) {
        throw new Error("当前页面不是 x-shop OSS 页面");
    }

    const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

    const visible = el => {
        const s = getComputedStyle(el);
        return s.display !== "none" &&
            s.visibility !== "hidden" &&
            el.getBoundingClientRect().width > 0;
    };

    const findText = text =>
        [...document.querySelectorAll("button, span, [role='button']")]
            .find(el => visible(el) && el.textContent?.replace(/\s/g, "").includes(text));

    const waitFor = async (fn, timeout = 15000) => {
        const start = Date.now();
        while (Date.now() - start < timeout) {
            const el = fn();
            if (el) return el;
            await sleep(300);
        }
        return null;
    };

    while (true) {
        const checkbox = await waitFor(() =>
            document.querySelector(
                "div.xcomponent-row-align-bottom > div.sc-1hvuehn-1 input"
            )
        );

        if (!checkbox) {
            console.log("没有找到对象选择框，可能已经清空。");
            continue;
        }

        checkbox.click();
        await sleep(700);

        const deleteButton = await waitFor(() => findText("彻底删除"));
        if (!deleteButton) throw new Error("没有找到“彻底删除”按钮");

        deleteButton.click();

        const confirmButton = await waitFor(() => {
            return (
                document.querySelector("body > div.xcomponent-overlay-wrapper.opened > div > div.xcomponent-balloon-content > div > div.oss-rc-inline-confirm-buttons > button.xcomponent-btn.xcomponent-small.xcomponent-btn-primary.oss-rc-x-button")
            );
        }, 15000);

        if (!confirmButton) {
            console.warn("确认弹窗未出现，当前批次停止。");
            continue;
        }

        confirmButton.click();
        console.log("已删除一批对象，继续检查……");

        await sleep(4000);
    }
})();
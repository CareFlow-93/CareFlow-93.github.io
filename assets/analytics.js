(function () {
    "use strict";

    var config = window.CAREFLOW_ANALYTICS || {};
    var url = String(config.url || "").replace(/\/+$/, "");
    var key = String(config.key || "");
    if (!url || !key) return;

    var sessionId = null;
    try {
        sessionId = sessionStorage.getItem("cf_session");
        if (!sessionId) {
            if (window.crypto && crypto.randomUUID) {
                sessionId = crypto.randomUUID();
                sessionStorage.setItem("cf_session", sessionId);
            }
        }
    } catch (e) {
        sessionId = null;
    }

    function deviceType() {
        var width = window.innerWidth || 0;
        if (width < 700) return "mobile";
        if (width < 1024) return "tablet";
        return "desktop";
    }

    function trim(value, max) {
        if (value === null || value === undefined) return null;
        var text = String(value).replace(/\s+/g, " ").trim();
        if (!text) return null;
        return text.slice(0, max);
    }

    function referrerHost() {
        if (!document.referrer) return null;
        try {
            return new URL(document.referrer).hostname.slice(0, 100);
        } catch (e) {
            return null;
        }
    }

    function send(event, label, product) {
        var payload = {
            event: trim(event, 40),
            path: trim(location.pathname, 200),
            lang: trim(document.documentElement.lang, 8),
            label: trim(label, 100),
            product: trim(product, 100),
            referrer_host: referrerHost(),
            session_id: sessionId,
            device: deviceType()
        };

        try {
            fetch(url + "/rest/v1/site_events", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "apikey": key,
                    "Authorization": "Bearer " + key,
                    "Prefer": "return=minimal"
                },
                body: JSON.stringify(payload),
                keepalive: true
            }).catch(function () {});
        } catch (e) {}
    }

    window.CareFlowTrack = send;

    send("page_view");

    document.addEventListener("click", function (event) {
        var target = event.target;
        if (!target || !target.closest) return;

        var el = target.closest("a, button");
        if (!el) return;

        var href = el.getAttribute("href") || "";
        var label = el.getAttribute("data-track-label") || el.getAttribute("aria-label") || el.textContent;

        if (href.indexOf("wa.me") > -1) {
            send("whatsapp_click", label);
        } else if (href.indexOf("mail.google.com") > -1) {
            send("gmail_click", label);
        } else if (href.indexOf("mailto:") === 0) {
            send("mailto_click", label);
        } else if (el.classList.contains("js-quote")) {
            send("product_quote_click", label, el.getAttribute("data-product"));
        } else if (el.id === "copy-btn") {
            send("copy_click", label);
        } else if (el.classList.contains("lang-btn")) {
            send("lang_switch", el.getAttribute("data-lang"));
        } else if (href === "#quote") {
            send("quote_cta_click", label);
        }
    }, true);
})();

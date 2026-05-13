/* ============================================================
   ThinkLink Association main script
   ------------------------------------------------------------
   Reveals elements with the .reveal class as they scroll into
   view. Adds .is-in once, then stops observing.
   ============================================================ */

(function () {
  "use strict";

  const REVEAL_SELECTOR = ".reveal";
  const ACTIVE_CLASS = "is-in";

  const init = () => {
    const targets = document.querySelectorAll(REVEAL_SELECTOR);
    if (!targets.length) return;

    // Fallback: no IntersectionObserver, just reveal everything.
    if (!("IntersectionObserver" in window)) {
      targets.forEach((el) => el.classList.add(ACTIVE_CLASS));
      return;
    }

    const observer = new IntersectionObserver(
      (entries, obs) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          entry.target.classList.add(ACTIVE_CLASS);
          obs.unobserve(entry.target);
        });
      },
      {
        threshold: 0.12,
        rootMargin: "0px 0px -60px 0px",
      }
    );

    targets.forEach((el) => observer.observe(el));
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();

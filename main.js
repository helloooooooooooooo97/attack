(() => {
  const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  if (reduced) return;

  const items = document.querySelectorAll(".service-list li, .playbooks li");
  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("in-view");
        io.unobserve(entry.target);
      });
    },
    { threshold: 0.2 }
  );

  items.forEach((el, i) => {
    el.style.opacity = "0";
    el.style.transform = "translateY(12px)";
    el.style.transition = `opacity 0.55s ease ${i * 0.06}s, transform 0.55s ease ${i * 0.06}s`;
    io.observe(el);
  });

  const style = document.createElement("style");
  style.textContent = `.in-view { opacity: 1 !important; transform: translateY(0) !important; }`;
  document.head.appendChild(style);
})();

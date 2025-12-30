// Hotkeys: Ctrl/Cmd + ArrowLeft/ArrowRight

document.addEventListener("keydown", (event) => {
  if (!(event.ctrlKey || event.metaKey)) return;
  if (event.altKey) return;

  const target = event.target;
  const isTypingField =
    target instanceof HTMLElement &&
    (target.isContentEditable ||
      target.tagName === "INPUT" ||
      target.tagName === "TEXTAREA" ||
      target.tagName === "SELECT");

  if (isTypingField) return;

  if (event.key === "ArrowLeft") {
    goToUrl(event, ctrlLeftUrl);
  } else if (event.key === "ArrowRight") {
    goToUrl(event, ctrlRightUrl);
  }
});

function goToUrl(event, href) {
  const url = (href ?? "").trim();
  if (!url) return;

  event.preventDefault();
  window.location.assign(url);
}

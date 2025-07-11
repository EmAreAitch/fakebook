// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

let sidebar = document.getElementById("sidebar");

document.addEventListener("turbo:load", () => {
  if (!(sidebar?.isConnected)) {
    sidebar = document.getElementById("sidebar");
  }
  sidebar?.classList.add("-translate-x-full")
  const messagesContainer = document.getElementById("messages");
  if (!messagesContainer) return;

  const observer = new MutationObserver(() => {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  });

  observer.observe(messagesContainer, {
    childList: true,
    subtree: true,
  });

  // Initial scroll
  messagesContainer.scrollTop = messagesContainer.scrollHeight;
});

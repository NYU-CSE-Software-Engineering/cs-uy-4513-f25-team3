function toggleDetails(button) {
  const targetId = button.getAttribute("data-message-details-target")
  if (!targetId) return

  const details = document.getElementById(targetId)
  if (!details) return

  const isHidden = details.classList.contains("is-hidden")
  details.classList.toggle("is-hidden", !isHidden)
  details.setAttribute("aria-hidden", String(!isHidden))
  button.setAttribute("aria-expanded", String(isHidden))
}

function registerMessageDetailsToggles() {
  document
    .querySelectorAll("[data-message-details-target]")
    .forEach((button) => {
      if (button.dataset.detailsBound === "true") return
      button.dataset.detailsBound = "true"
      button.addEventListener("click", () => toggleDetails(button))
    })
}

document.addEventListener("turbo:load", registerMessageDetailsToggles)
document.addEventListener("DOMContentLoaded", registerMessageDetailsToggles)

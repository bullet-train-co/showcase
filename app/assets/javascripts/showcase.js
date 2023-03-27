window.customElements.define("showcase-sample", class extends HTMLElement {
  connectedCallback() {
    this.events.forEach((name) => this.addEventListener(name, this.emit))
  }

  disconnectedCallback() {
    this.events.forEach((name) => this.removeEventListener(name, this.emit))
  }

  emit(event) {
    console.log({ originator: this, event })
    this.relay(event)
  }

  relay({ type, detail }) {
    const node = document.createElement("div")
    node.innerHTML = JSON.stringify({ type, detail })
    this.relayTarget?.appendChild(node)
  }

  get relayTarget() {
    return this.querySelector("[data-showcase-sample-target='relay']")
  }

  get events() {
    return JSON.parse(this.getAttribute("events")) || []
  }
})

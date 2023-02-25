window.customElements.define("showcase-isolated-context", class extends HTMLElement {
  constructor() {
    super()
    this.attachShadow({ mode: "open" })
  }

  connectedCallback() {
    if (!this.shadowRoot.length)
      this.shadowRoot.appendChild(this.#shadowRootContents)
  }

  get #shadowRootContents() {
    return this.parentNode.querySelector("[data-shadowroot]").content.cloneNode(true)
  }
})

window.customElements.define("showcase-sample", class extends HTMLElement {
  connectedCallback() {
    this.events.forEach((name) => this.addEventListener(name, this.emit))
  }

  disconnectedCallback() {
    this.events.forEach(this.removeEventListener)
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

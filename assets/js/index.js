import ExEditorView from './ExEditorView';

const proseInstances = document.getElementsByClassName('ex-prosemirror');

/**
 * ExProsemirror manage prosemirror in elixir project.
 */
class ExProsemirror {
  constructor() {
    this.initAll();
  }

  /**
   * Initializes all prosemirror instances.
   */
  initAll() {
    Array.from(proseInstances).forEach(el => {
      this.init(el);
    });
  }

  /**
   * Initializes the specified target (should be an ex_prosemirror instance).
   *
   * @param {any} target - target to initialize.
   */
  init(target) {
    target.innerHTML = '';
    return new ExEditorView(target);
  }
}

export default new ExProsemirror();

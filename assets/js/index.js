import ExEditorView from './ExEditorView';

/**
 * @type {NodeListOf<HTMLElement>} proseInstances
 */
const proseInstances = document.querySelectorAll('.ex-prosemirror');

/**
 * ExProsemirror manage prosemirror in elixir project.
 */
class ExProsemirror {
  /**
   * @param {[Object]} blocks
   */
  setCustomBlocks(blocks) {
    this.customBlocks = blocks;
  }

  /**
   * @param {[Object]} marks
   */
  setCustomMarks(marks) {
    this.customMarks = marks;
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
   * @param {Element} target - target to initialize.
   */
  init(target) {
    if (target instanceof HTMLElement) {
      target.innerHTML = '';
      return new ExEditorView(target, {customBlocks: this.customBlocks, customMarks: this.customMarks});
    }

    return null;
  }
}

export default new ExProsemirror();

import { exampleSetup as pluginFunc } from 'prosemirror-example-setup';
import schemaFunc from '../prosemirror/schema';
import exProsemirror from '../index';

const ExProsemirrorHooks = {};

ExProsemirrorHooks.MountProseMirror = {
  mounted() {
    exProsemirror.init(this.el, { schemaFunc, pluginFunc });
  },
  updated() {
    // transforms the following schema rules
    exProsemirror.init(this.el, { schemaFunc, pluginFunc });
  },
};

export { ExProsemirrorHooks };

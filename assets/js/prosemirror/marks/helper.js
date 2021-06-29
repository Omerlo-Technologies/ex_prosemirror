/**
 * Toggle color text for cursor OR selected element.
 */
export function toggleMultiMarks(markType, attrs) {
  return function(state, dispatch) {
    let {empty, $cursor, ranges} = state.selection;
    if (empty && !$cursor) return false;

    if (dispatch) {
      if ($cursor) {
        if (markType.isInSet(state.storedMarks || $cursor.marks())) {
          dispatch(state.tr.removeStoredMark(markType));
        }

        if (attrs) {
          dispatch(state.tr.addStoredMark(markType.create(attrs)));
        }
      } else {
        let has = false, tr = state.tr;
        for (let i = 0; !has && i < ranges.length; i++) {
          let {$from, $to} = ranges[i];
          has = state.doc.rangeHasMark($from.pos, $to.pos, markType);
        }
        for (let i = 0; i < ranges.length; i++) {
          let { $from, $to } = ranges[i];
          let from = $from.pos, to = $to.pos, start = $from.nodeAfter, end = $to.nodeBefore;
          let spaceStart = start && start.isText ? /^\s*/.exec(start.text)[0].length : 0;
          let spaceEnd = end && end.isText ? /\s*$/.exec(end.text)[0].length : 0;
          if (from + spaceStart < to) { from += spaceStart; to -= spaceEnd; }
          if (attrs) {
            tr.addMark(from, to, markType.create(attrs));
          } else {
            tr.removeMark(from, to, markType);
          }
        }

        dispatch(tr.scrollIntoView());
      }
    }
    return true;
  };
}

/**
 * Returns a function that will generate Marks for Prosemirror schema.
 */
export const generateExProsemirrorMarks = ( marksSelection, marks ) => {
  const result = {};

  marksSelection.map((/** @type {Object} */ element) => {
    if (marks[element.type]) {
      result[element.type] = { ...marks[element.type], config: element };
    }
  });

  return result;
};

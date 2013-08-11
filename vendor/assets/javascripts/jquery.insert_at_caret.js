$.fn.extend({
    changeCase: function() {
      var symbol = this.text();
      if (symbol == symbol.toLowerCase()) {
        this.text(symbol.toUpperCase());
      } else {
        this.text(symbol.toLowerCase());
      }
    },

    insertAtCaret: function(myValue) {
        input = this.get(0)
        if (document.selection) {
                this.focus();
                sel = document.selection.createRange();
                sel.text = myValue;
                this.focus();
        }
        else if (input.selectionStart || input.selectionStart == '0') {
            var startPos = input.selectionStart;
            var endPos = input.selectionEnd;
            var scrollTop = input.scrollTop;
            input.value = input.value.substring(0, startPos)+myValue+input.value.substring(endPos,input.value.length);
            this.focus();
            input.selectionStart = startPos + myValue.length;
            input.selectionEnd = startPos + myValue.length;
            input.scrollTop = scrollTop;
        } else {
            input.value += myValue;
            this.focus();
        }
    }
})

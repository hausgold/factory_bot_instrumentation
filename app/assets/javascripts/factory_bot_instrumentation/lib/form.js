window.Form = Form = function(scope)
{
  this.button = $(scope).find('button');
  this.result = $('#result');
  this.spinner = $('#spinner');
};

Form.prototype.bind = function(action)
{
  this.button.on('click', (event) => {
    event.preventDefault();
    this.hideResult();
    action(event);
    return false;
  });
};

Form.prototype.hideResult = function()
{
  this.result.hide();
  this.button.prop('disabled', true);
  this.spinner.show();
};

Form.prototype.showResultContainer = function(html)
{
  this.result.html(html);
  $('pre').each((i, block) => hljs.highlightBlock(block));
  new ClipboardJS('.cb-copy');
  this.result.show();
  this.button.prop('disabled', false);
};

Form.prototype.showError = function(payload, output)
{
  this.spinner.hide();
  output = window.utils.prepareOutput(output);
  this.errorContent(payload, output, (err, html) => {
    this.showResultContainer(html);
  });
};

Form.prototype.errorContent = function(payload, output, cb)
{
  cb(null, `
    <pre id="data">${output}</pre>
    ${window.utils.clipboardButton()}
  `);
};

Form.prototype.showResult = function(payload, output)
{
  this.spinner.hide();
  output = window.utils.prepareOutput(output);
  this.resultContent(payload, output, (err, html) => {
    this.showResultContainer(html);
  });
};

Form.prototype.resultContent = function(payload, output, cb)
{
  cb(null, `
    <pre id="data">${output}</pre>
    ${window.utils.clipboardButton()}
  `);
};

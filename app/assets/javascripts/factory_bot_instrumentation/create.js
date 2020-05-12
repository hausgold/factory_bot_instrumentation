window.CreateForm = CreateForm = function()
{
  this.scope = '#generate';
  this.form = new Form(this.scope);
  this.scenarios = window.scenarios;
  this.select = $(`${this.scope} .scenario`);
  this.desc = $(`${this.scope} .description`);

  let self = this;

  this.form.errorContent = function(payload, output, cb)
  {
    window.utils.waterfallWithHooks({
      data: {
        alert: `An unexpected error occured. Looks like something went wrong
                while generating your new entity. This migth be a bug, or an
                unexpected feature. It could be a temporary issue. When is is
                persistent contact your friendly API Instrumentation
                administrator.`,
        output: output,
        payload: payload,
        pre: '',
        post: ''
      },
      pre: window.hooks.preCreateError,
      post: window.hooks.postCreateError,
      action: (payload, innerCb) => {
        cb(null, `
          ${payload.pre}
          <div class="alert alert-danger" role="alert">${payload.alert}</div>
          <pre id="data">${payload.output}</pre>
          ${window.utils.clipboardButton()}
          ${payload.post}
        `);
        innerCb(null, payload);
      }
    });
  };

  this.form.resultContent = function(payload, output, cb)
  {
    let card = window.utils.card({
      body: `
        <pre id="data">${output}</pre>
        ${window.utils.clipboardButton()}
      `
    });

    window.utils.waterfallWithHooks({
      data: {
        alert: `A new ${self.scenario().name.toLowerCase()} was created.`,
        output: output,
        payload: payload,
        cards: [card],
        pre: '',
        post: '',
        openCard: '#details'
      },
      pre: window.hooks.preCreateResult,
      post: window.hooks.postCreateResult,
      action: (payload, innerCb) => {
        cb(null, `
          ${payload.pre}
          <div class="alert alert-success" role="alert">${payload.alert}</div>
          <div class="accordion" id="response">
            ${payload.cards.join(' ')}
          </div>
          ${payload.post}
        `);
        innerCb(null, payload);
        if (payload.openCard) {
          $(
            `.accordion#response button[data-target="${payload.openCard}"]`
          ).click();
        }
      }
    });
  };
};

CreateForm.prototype.updateDesc = function()
{
  this.desc.html(this.scenario().desc);
};

CreateForm.prototype.activeScenario = function()
{
  raw = this.select.find(':selected').val().split('/');
  return { group: raw[0], index: raw[1] };
};

CreateForm.prototype.scenario = function()
{
  scenario = this.activeScenario();
  return this.scenarios[scenario.group][scenario.index];
};

CreateForm.prototype.bind = function()
{
  this.form.bind((event) => {
    this.submit();
  });

  this.select.on('change', this.updateDesc.bind(this));
  this.updateDesc();
};

CreateForm.prototype.submit = function()
{
  let form = this.form;
  let conf = this.scenario();

  window.utils.waterfallWithHooks({
    data: {
      factory: conf.factory,
      traits: conf.traits,
      overwrite: conf.overwrite
    },
    pre: window.hooks.preCreate,
    post: window.hooks.postCreate,
    action: (payload, cb) => {
      window.utils.request({
        url: window.createUrl,
        data: JSON.stringify(payload)
      }, (err, result) => {
        if (err) { return cb && cb(err); }
        cb(null, { request: payload, response: result });
      });
    }
  }, function(err, result) {
    if (err) { return form.showError(err, err.responseText); }
    form.showResult(result, result.response);
  });
};

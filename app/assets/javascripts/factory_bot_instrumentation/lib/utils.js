window.utils = Utils = {};

Utils.pushWaterfallPayload = function(data)
{
  return (cb) => cb(null, data);
};

Utils.waterfallWithHooks = function(opts, cb)
{
  cb = cb || function(){};
  opts = Object.assign({
    pre: [],
    post: [],
    data: {},
    action: (payload, cb) => cb(null, payload)
  }, opts);

  async.waterfall([
    // Yield the data to pre hooks
    Utils.pushWaterfallPayload(opts.data),
    // Perform pre hooks
    ...opts.pre,
    // Perform the create request
    opts.action,
    // Perform post hooks
    ...opts.post
  ], cb);
};

Utils.request = function(opts, cb)
{
  opts = Object.assign({
    url: '/',
    type: 'POST',
    data: '{}',
    dataType: 'json',
    contentType: 'application/json; charset=utf-8',
    ignoreErrors: false
  }, opts || {}, {
    success: (result) => cb(null, result)
  });

  errCb = (err) => cb(err);
  if (opts.ignoreErrors) {
    errCb = (err) => cb(null, err);
  }

  $.ajax(opts).fail(errCb);
};

Utils.escape = function(str)
{
  return str.replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;");
};

Utils.prepareOutput = function(output)
{
  try {
    if (typeof output !== 'object') { output = JSON.parse(output); }
    output = JSON.stringify(output, null, 2);
  } catch { }

  return window.utils.escape(output);
};

Utils.clipboardButton = function(id)
{
  id = id || 'data';
  return `
    <span class="btn btn-primary cb-copy"
      data-clipboard-target="#${id}">
      <i class="fas fa-paste"></i> Copy result to clipboard
    </span>
  `;
};

Utils.clipboardBadge = function(id)
{
  id = id || 'data';
  return `
    <span class="badge badge-dark cb-copy" title="Copy result to clipboard"
          data-clipboard-target="#${id}"><i class="fas fa-paste"></i>
    </span>
  `;
};

Utils.card = function(opts)
{
  opts = Object.assign({
    id: 'details',
    icon: 'fa-asterisk',
    title: 'Details',
    body: ''
  }, opts || {});

  return `
    <div class="card">
      <div class="card-header">
        <h5 class="mb-0">
          <button class="btn btn-link collapsed" type="button"
            data-toggle="collapse" data-target="#${opts.id}"
            aria-expanded="false">
            <i class="fas ${opts.icon}"></i> ${opts.title}</h5>
          </button>
        </h5>
      </div>
      <div id="${opts.id}" class="collapse" data-parent="#response">
        <div class="card-body">
          ${opts.body}
        </div>
      </div>
    </div>
  `;
};

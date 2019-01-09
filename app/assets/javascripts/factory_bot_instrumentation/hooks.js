// You can define some custom hooks to enhance the functionality. With the help
// of the following hooks you are able to customize the outputs, perform
// additional HTTP requests or anything you like.
//
// All the hooks are designed to passthrough a payload. They receive this
// payload as the first argument, and a callback function to signal the end of
// the hook. You MUST pass the payload as second parameter to the callback, or
// pass an error object as first argument. You can modify the payload as you
// wish, eg. adding some data from subsequent requests.
//
// Example hooks:
//
//   // Error case
//   window.hooks.postCreate.push((payload, cb) => {
//     cb({ error: true});
//   });
//
//   // Happy case
//   window.hooks.postCreate.push((payload, cb) => {
//     cb(null, Object.assign(payload, { additional: { data: true } }));
//   });
//
// Mind the fact that you can define multiple custom functions per hook type.
// They are executed after each other in a waterfall like flow. The order of
// the hooks array is therefore essential.
window.hooks = {
  // With the help of the +perCreate+ hooks you can manipulate the create
  // request parameters. Think of an additional handling which reads an
  // overwrite form or a kind of trait checkboxes to customize the factory
  // call. The +payload+ looks like this:
  //
  //   {
  //     factory: 'user',
  //     traits: ['confirmed'],
  //     overwrite: { password: 'secret' }
  //   }
  preCreate: [],

  // The +postCreate+ hook allows you to perform subsequent requests to fetch
  // additional data. Think of a user instrumentation where you want to request
  // a one time token for this user. This token can be added to the payload and
  // can be shown with the help of the +preCreateResult+ hook. The payload
  // contains the request parameters and the response body from the
  // instrumentation request. Here comes an example +payload+:
  //
  //   {
  //     request: { factory: 'user', /* [..] */ },
  //     response: { /* [..] */ }
  //   }
  postCreate: [],

  // With the help of the +preCreateResult+ hook you can customize the output
  // of the result. You could also perform some subsequent requests or some UI
  // preparations. You can access the output options and the runtime payload
  // with all its data and make modifications to them. This hook is triggered
  // before the result is rendered. A sample payload comes here:
  //
  //   {
  //     alert: 'Your alert text.',
  //     output: 'Formatted response',
  //     payload: { request: { /* [..] */ }, response: { /* [..] */ } },
  //     cards: [
  //       `The details accordion card,
  //        you can add more, remove the details card
  //        or reorder them`
  //     ],
  //     openCard: '#details', // Open a custom card, or none
  //     pre: 'Additinal HTML content before the alert.',
  //     post: 'Additinal HTML content after the formatted response output.'
  //   }
  preCreateResult: [],

  // In case you want to perform some logic after the result is rendered, you
  // can use the +postCreateResult+ hook. You can access the output options and
  // the runtime payload with all its data, but changes to them won't take
  // effect. The +payload+ looks like this:
  //
  //   {
  //     alert: 'Your alert text.',
  //     output: 'Formatted response',
  //     payload: { request: { /* [..] */ }, response: { /* [..] */ } },
  //     cards: [
  //       `The details accordion card,
  //        you can add more, remove the details card
  //        or reorder them`
  //     ],
  //     openCard: '#details', // Open a custom card, or none
  //     pre: 'Additinal HTML content before the alert.',
  //     post: 'Additinal HTML content after the formatted response output.'
  //   }
  postCreateResult: [],

  // With the help of the +preCreateError+ hook you can customize the output of
  // the error. Furthermore you can perform some subsequent requests or
  // whatever comes to your mind. You can access the output options and the
  // runtime payload with all its data and make modifications to them. This
  // hook is triggered before the error is rendered. A sample payload comes
  // here:
  //
  //   {
  //     alert: 'Your alert text.',
  //     output: 'Formatted response',
  //     payload: { request: { /* [..] */ }, response: { /* [..] */ } },
  //     pre: 'Additinal HTML content before the alert.',
  //     post: 'Additinal HTML content after the formatted response output.'
  //   }
  preCreateError: [],

  // In case you want to perform some magic after an error occured, you can use
  // the +postCreateError+ hook. You can access the output options and the
  // runtime payload with all its data, but changes to them won't take effect
  // because this hook is triggered after the error is rendered. The +payload+
  // looks like this:
  //
  //   {
  //     alert: 'Your alert text.',
  //     output: 'Formatted response',
  //     payload: { request: { /* [..] */ }, response: { /* [..] */ } },
  //     pre: 'Additinal HTML content before the alert.',
  //     post: 'Additinal HTML content after the formatted response output.'
  //   }
  postCreateError: []
};

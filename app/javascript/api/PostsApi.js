// JsFromRoutes CacheKey 3fbdf581393e62f87330e9c114f2ee2f
//
// DO NOT MODIFY: This file was automatically generated by JsFromRoutes.
import { definePathHelper } from '@js-from-routes/client'

export default {
  like: /* #__PURE__ */ definePathHelper('post', '/posts/:id/like'),
  unlike: /* #__PURE__ */ definePathHelper('delete', '/posts/:id/like'),
  explore: /* #__PURE__ */ definePathHelper('get', '/posts/explore'),
  index: /* #__PURE__ */ definePathHelper('get', '/posts'),
  root: /* #__PURE__ */ definePathHelper('get', '/'),
  create: /* #__PURE__ */ definePathHelper('post', '/posts'),
  new: /* #__PURE__ */ definePathHelper('get', '/posts/new'),
  edit: /* #__PURE__ */ definePathHelper('get', '/posts/:id/edit'),
  show: /* #__PURE__ */ definePathHelper('get', '/posts/:id'),
  update: /* #__PURE__ */ definePathHelper('patch', '/posts/:id'),
  destroy: /* #__PURE__ */ definePathHelper('delete', '/posts/:id'),
}

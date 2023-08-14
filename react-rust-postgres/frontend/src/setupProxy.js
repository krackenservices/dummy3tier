const { createProxyMiddleware } = require("http-proxy-middleware");

module.exports = function(app) {
  app.use(
    "/api",
    createProxyMiddleware({
      target: "http://backend.default.svc.cluster.local:8080",
      //target: "http://backend:8000",
      //target: "http://127.0.0.1:8000",
      //target: `http://${process.env.REACT_APP_BACKEND}`,
      //target: `http://${process.env.REACT_APP_BACKEND}`,
      pathRewrite: { "^/api": "" }
    })
  );
};

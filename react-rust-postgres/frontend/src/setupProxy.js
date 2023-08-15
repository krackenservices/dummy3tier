const { createProxyMiddleware } = require("http-proxy-middleware");

module.exports = function(app) {
  app.use(
    "/api",
    createProxyMiddleware({
      //target: "http://backend:8000", // Docker Compose value
      target: `http://${process.env.REACT_APP_BACKEND}`,
      pathRewrite: { "^/api": "" }
    })
  );
};

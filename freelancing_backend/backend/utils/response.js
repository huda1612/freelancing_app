const success = (res, data, message = "success") => {
  return res.status(200).json({
    // success: true,
    message,
    ...data,
  });
};

const badRequest = (res, message = "bad request") => {
  return res.status(400).json({
    // success: false,
    message,
  });
};

const unauthorized = (res, message = "unauthorized") => {
  return res.status(401).json({
    // success: false,
    message,
  });
};

const forbidden = (res, message = "forbidden") => {
  return res.status(403).json({
    // success: false,
    message,
  });
};

const notFound = (res, message = "not found") => {
  return res.status(404).json({
    // success: false,
    message,
  });
};

const serverError = (res, error) => {
  return res.status(500).json({
    // success: false,
    message: error.message || "internal server error",
  });
};

module.exports = {
  success,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  serverError,
};
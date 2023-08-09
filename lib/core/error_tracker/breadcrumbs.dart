/// An enum of types of breadcrumbs.
/// Ref: https://develop.sentry.dev/sdk/event-payloads/breadcrumbs/#breadcrumb-types
enum BreadCrumbType {
  /// Describes a generic breadcrumb.
  ///
  /// This is typically a log message or user-generated breadcrumb. The `data`
  /// part is entirely undefined and as such, completely rendered as a key/value
  /// table.
  default_,

  /// This is typically a log message.
  ///
  /// The data part is entirely undefined and as such, completely rendered as a
  /// key/value table.
  debug,

  /// An error that occurred before the exception.
  error,

  /// A navigation event can be a URL change in a web application, or a UI
  /// transition in a mobile or desktop application, etc.
  ///
  /// Its data property has the following sub-properties:
  /// * from (required): A string representing the original state / location.
  /// * to (required): A string representing the new state / location.
  navigation,

  /// This represents an HTTP request transmitted from your application.
  /// This could be an AJAX request from a web application, or a
  /// server-to-server HTTP request to an API service provider, etc.
  ///
  /// Its data property has the following sub-properties:
  /// * url (optional): The request URL.
  /// * method (optional): The HTTP request method.
  /// * status_code (optional): The HTTP status code of the response.
  /// * reason (optional): Text that describes the status code.
  http,

  /// Information that helps identify the root cause of the issue or for whom
  /// the error occurred.
  info,

  /// This represents a query that was made in your application.
  query,

  /// Describes a tracing event.
  transaction,

  /// A user interaction with your app's UI.
  ui,

  /// A user interaction with your app's UI.
  user,
}

extension BreadCrumbTypeExtension on BreadCrumbType {
  String value() {
    if (this == BreadCrumbType.default_) return 'default';
    return name;
  }
}

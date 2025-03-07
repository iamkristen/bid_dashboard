String removeExceptionPrefix(String input) {
  const prefix = "Exception: ";
  if (input.startsWith(prefix)) {
    return input.substring(prefix.length); // Remove the prefix
  }
  return input; // Return as is if no prefix
}

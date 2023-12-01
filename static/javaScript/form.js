const inputs = document.querySelectorAll("input");

const checkInputForm = (input) => {
  if (input.value === "" || input.value === " ") {
    input.classList.remove("has-text");
  } else {
    input.classList.add("has-text");
  }
};

document.addEventListener("DOMContentLoaded", () => {
  inputs.forEach((input) => {
    checkInputForm(input);
  });
});

inputs.forEach((input) => {
  input.addEventListener("input", () => {
    checkInputForm(input);
  });
});

const burger = document.querySelector(".burger")
const cross = document.getElementById("close-nav")

burger.addEventListener("click", () => {
    burger.classList.add('active')
})

cross.addEventListener("click", () => {
    burger.classList.remove("active")
})
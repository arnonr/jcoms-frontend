
import Toastify from "toastify-js";
import "toastify-js/src/toastify.css";

export default (text, type) => {
  let style = {
    background: "linear-gradient(to right, #00b09b, #96c93d)",
  };
  if (type == "error") {
    style = {
      backgroundColor: "#c62128",
      backgroundImage: "linear-gradient(147deg, #c62128 0%, #a00000 74%)",
    };
  }

  Toastify({
    text: text,
    duration: 3000,
    //   destination: "https://github.com/apvarun/toastify-js",
    newWindow: true,
    close: true,
    gravity: "bottom", // `top` or `bottom`
    position: "center", // `left`, `center` or `right`
    stopOnFocus: true, // Prevents dismissing of toast on hover
    style: style,
    onClick: function () {}, // Callback after click
  }).showToast();
};

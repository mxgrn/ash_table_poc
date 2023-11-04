// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Sortable from "../vendor/sortable"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {}

Hooks.Resizable = {
  mounted() {
    resizableGrid(this.el, this)
  },
  // So it keeps working after liveview updates
  updated() {
    this.mounted()
  },
}

Hooks.Sortable = {
  mounted() {
    window.sortable = new Sortable(this.el, {
      animation: 150,
      delay: 100,
      dragClass: "text-gray-700",
      ghostClass: "bg-gray-100",
      forceFallback: true,
      onEnd: e => {
        let params = { old: e.oldIndex, new: e.newIndex, ...e.item.dataset }
        this.pushEventTo(this.el, "reposition", params)
      }
    })
  },
}


let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

//var tables = document.getElementsByClassName('flexiCol');
var tables = document.getElementsByClassName('resizable');
for (var i = 0; i < tables.length; i++) {
  resizableGrid(tables[i]);
}



function resizableGrid(table, hook) {
  var row = table.getElementsByTagName('tr')[0],
    cols = row ? row.children : undefined;
  if (!cols) return;

  table.style.overflow = 'hidden';

  var tableHeight = table.offsetHeight;

  for (var i = 0; i < cols.length; i++) {
    var div = createDiv(tableHeight);
    cols[i].appendChild(div);
    cols[i].style.position = 'relative';
    setListeners(div);
  }

  function setListeners(div) {
    var pageX, curCol, nxtCol, curColWidth, nxtColWidth, tableWidth;

    div.addEventListener('mousedown', function(e) {

      tableWidth = document.getElementById('tableId').offsetWidth;
      curCol = e.target.parentElement;
      nxtCol = curCol.nextElementSibling;
      pageX = e.pageX;

      var padding = paddingDiff(curCol);

      curColWidth = curCol.offsetWidth - padding;
      //  if (nxtCol)
      //nxtColWidth = nxtCol.offsetWidth - padding;
    });

    div.addEventListener('mouseover', function(e) {
      window.sortable.option("disabled", true);
      e.target.style.borderRight = '2px solid #888888';
    })

    div.addEventListener('mouseout', function(e) {
      window.sortable.option("disabled", false);
      e.target.style.borderRight = '';
    })

    document.addEventListener('mousemove', function(e) {
      if (curCol) {
        var diffX = e.pageX - pageX;

        curCol.style.width = (curColWidth + diffX) + 'px';
        document.getElementById('tableId').style.width = tableWidth + diffX + "px"
      }
    });

    document.addEventListener('mouseup', function(_e) {
      if (curCol) {
        hook.pushEventTo(table, "resize", { width: parseInt(curCol.style.width), index: parseInt(curCol.dataset.index) })
      }

      // console.log(this)

      curCol = undefined;
      nxtCol = undefined;
      pageX = undefined;
      nxtColWidth = undefined;
      curColWidth = undefined
    });
  }

  function createDiv(height) {
    var div = document.createElement('div');
    div.style.top = 0;
    div.style.right = 0;
    div.style.width = '5px';
    div.style.position = 'absolute';
    div.style.cursor = 'col-resize';
    div.style.userSelect = 'none';
    div.style.height = height + 'px';
    return div;
  }

  function paddingDiff(col) {

    if (getStyleVal(col, 'box-sizing') == 'border-box') {
      return 0;
    }

    var padLeft = getStyleVal(col, 'padding-left');
    var padRight = getStyleVal(col, 'padding-right');
    return (parseInt(padLeft) + parseInt(padRight));

  }

  function getStyleVal(elm, css) {
    return (window.getComputedStyle(elm, null).getPropertyValue(css))
  }
};

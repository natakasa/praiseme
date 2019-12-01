// vue
import Vue from 'vue/dist/vue.esm';

document.addEventListener('DOMContentLoaded', function() {

    var app = new Vue({
        el: ".infomation",
        data: {
            isOpen: false
        },
        methods: {
            infoSwich: function () {
                this.isOpen = !this.isOpen
            },
            infoClose: function () {
                this.isOpen = false
            }
        }
    });

    var app = new Vue({
        el: ".char_select_area",
        data: {
            isOpen: true
        },
        methods: {
            charSwich: function () {
                this.isOpen = !this.isOpen
            }
        }
    });

});

// jquery
// todo vueで実装、リスト化
$(document).on('click', '#char-select-01', function() {
    // alert( "char-select" )
    window.location.reload();
});

$(document).on('click', '#char-select-02', function() {
    $('#char_no').val('02');
    document.body.style.backgroundColor = "#fcf8e3 !important";
    document.body.style.backgroundImage = "url(" + "/assets/02/back.png" + ")";
    document.getElementById("facea").src= "/assets/02/face01.png"
    document.getElementById("faceb").src= "/assets/02/face02.png"
    document.getElementById("line-a").innerHTML= "いつもお疲れさまです。<br>今日はどんなことを頑張ったんですか…？"
    document.getElementById("line-b").innerHTML= "ぜひ皆さんにも見てもらいたいですね。"
});

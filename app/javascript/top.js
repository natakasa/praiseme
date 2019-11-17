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
            isOpen: false
        },
        methods: {
            charSwich: function () {
                this.isOpen = !this.isOpen
            }
        }
    });

});

/* jquery
$(document).on('click', '.infomation', function() {
    alert( "infomation" )
    $('.infomation_contents').show();
});
*/
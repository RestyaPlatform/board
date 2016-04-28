$(window).resize(function() {
    var headerH = $("header").height();
    var footerH = $("footer").height();
    var windowH = $(window).height();
    var notificationH = windowH - footerH;
    var boardH = windowH - headerH - footerH - 14;
    $(".board-list-view").css("height", (boardH + 'px'));
    $(".notification-list").css({
        'height': notificationH - 100,
        'overflow-y': 'scroll'
    });
    $('.member-modal.js-pre-scrollable').css({
        'max-height': boardH - 50,
        'overflow-y': 'auto'
    });
});
var $dc = $(document);
$dc.ready(function() {
    $dc.on('click', '.js-cancel-organization', function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    }).on('click', '.js-start', function(e) {
        var actionSheet = $('.action-sheet');
        if ($('#footer').hasClass('action-open')) {
            setTimeout(function() {
                actionSheet.removeClass('open');
            }, 10);
            $('#footer').removeClass('action-open');
        } else {
            setTimeout(function() {
                actionSheet.addClass('open');
            }, 10);
            $('#footer').addClass('action-open');
        }
    }).on('click', '.js-edit-organization', function(e) {
        $('.js-organization-view-block').hide();
        $('.js-organization-edit-block').show();
        return false;
    }).on('click', '.js-select', function(e) {
        $this = $(this);
        if ($this.data('unchecked')) {
            unchecked = $this.data('unchecked');
            $('.' + unchecked).prop('checked', false);
        }
        if ($this.data('checked')) {
            checked = $this.data('checked');
            $('.' + checked).prop('checked', 'checked');
        }
        return false;
    }).on('click', '.js-dropdown-popup', function(e) {
        e.stopPropagation();
    }).on('click', '.js-syn-calendar', function(e) {
        $.oauthpopup({
            path: $(this).data('url'),
            callback: function() {
                window.location.reload();
            }
        });
        return false;
    });
    if ((navigator.userAgent.toLowerCase().indexOf('android') > -1) && (navigator.userAgent.toLowerCase().indexOf('chrome') > -1)) {
        $('body').append('<div class="modal fade" id="add_home_modal" tabindex="-1" role="dialog" aria-hidden="false"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" id="js-cssilize-close">x</span><span class="sr-only">Close</span></button><div class="media list-group-item-heading"><div class="media-body"><h4 class="modal-title" id="exampleModalLabel">Install this webapp to your phone</h4></div></div></div><div class="modal-body import-block"><ul><li>Add Restyaboard to homescreen.</li><li>Tap <i class="icon-ellipsis-vertical"></i>to bring up your browser menu and select \'Add to homescreen\' to pin the Restyaboard web app.</li></ul></div></div></div></div>');
    }
});
(function($) {
    $.fn.serializeObject = function() {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
            if (this.name.indexOf('[') !== -1) {
                var val = this.value;
                this.name.replace(/([0-9a-z_-]+)\[(\d+)\]\[(\d+)\]/g, function($0, $1, $2, $3) {
                    if (typeof o[$1] === 'undefined') {
                        o[$1] = [];
                    }
                    if (typeof o[$1][$2] === 'undefined') {
                        o[$1][$2] = [];
                    }
                    o[$1][$2][$3] = val;
                });
            } else if (o[this.name] !== undefined) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };
})
(jQuery);

function changeTitle(title) {
    if (title !== undefined) {
        document.title = i18next.t("%s's Restyaboard | %s", {
            postProcess: 'sprintf',
            sprintf: [SITE_NAME, title]
        });
    }
}

function checkKeycode(keycode, c) {
    for (var b = 0, d = keycode.length; b < d; b++)
        if (b in keycode && keycode[b] === c) return b;
    return -1;
}

function makeLink(text, board_id) {
    text = text.replace(/#(\d+)/g, '<a class="js-open-card-view" data-card_id="$1" href="#/board/' + board_id + '/card/$1">#$1</a>');
    text = text.replace(/(@[^\s]*)/g, '<span class="atMention">$1</span>');
    return text;
}

var favicon = new Favico({
    animation: 'popFade'
});

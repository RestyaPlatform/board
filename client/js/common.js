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
    if ($.cookie('_geo') === null) {
        $.ajax({
            type: 'GET',
            url: '//freegeoip.net/json/',
            dataType: 'JSONP',
            cache: true,
            success: function(data) {
                data.country_code = (data.country_code !== undefined && data.country_code !== null) ? data.country_code : "";
                data.region = (data.region_name !== undefined && data.region_name !== null) ? data.region_name : "";
                data.city = (data.city !== undefined && data.city !== null) ? data.city : "";
                data.latitude = (data.latitude !== undefined && data.latitude !== null) ? data.latitude : "";
                data.longitude = (data.longitude !== undefined && data.longitude !== null) ? data.longitude : "";
                var geo = data.country_code + '|' + data.region + '|' + data.city + '|' + data.latitude + '|' + data.longitude;
                $.cookie('_geo', geo, {
                    expires: 100,
                    path: '/'
                });
            }
        });
    }
    $dc.on('click', '.js-cancel-organization', function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    }).on('click', '.js-start', function(e) {
        var actionSheet = $(".action-sheet");
        /* Grazie a modernizr riprendo il nome dell'evento di fine animazione, che cambia a seconda del browser */
        var endTransitionName = {
            'WebkitTransition': 'webkitTransitionEnd',
            'OTransition': 'oTransitionEnd',
            'msTransition': 'MSTransitionEnd',
            'transition': 'transitionend'
        };
        var transitionEventName = endTransitionName[Modernizr.prefixed('transition')];
        var X = $(this).attr('id');
        if (X == 1) {
            setTimeout(function() {
                actionSheet.removeClass("open"); //aggiungiamo la classe 'open' per avviare l'aniamzione
            }, 10);
            $(this).attr('id', '0');
            $("#footer").removeClass("action-open");
        } else {
            setTimeout(function() {
                actionSheet.addClass("open"); //aggiungiamo la classe 'open' per avviare l'aniamzione
            }, 10);
            $(this).attr('id', '1');
            $("#footer").addClass("action-open");
        }
    }).on('click', '.cancel', function(e) {
        var _endTransitionName = {
            'WebkitTransition': 'webkitTransitionEnd',
            'OTransition': 'oTransitionEnd',
            'msTransition': 'MSTransitionEnd',
            'transition': 'transitionend'
        };
        var _transitionEventName = _endTransitionName[Modernizr.prefixed('transition')];
        var _actionSheet = $(".action-sheet");
        _actionSheet.removeClass("open").one(_transitionEventName, function() {
            _actionSheet.hide();
        });
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
    document.title = SITE_NAME + "'s Restyaboard" + " | " + title;
}

function checkKeycode(keycode, c) {
    for (var b = 0, d = keycode.length; b < d; b++)
        if (b in keycode && keycode[b] === c) return b;
    return -1;
}

function makeLink(text, board_id) {
    var matches = text.match(/#(\d+)/g);
    if (matches !== undefined && matches !== null) {
        $.each(matches, function(key, val) {
            var temp = val.split('#');
            if (temp['1'] !== undefined) {
                var cardLink = '<a class="js-open-card-view" data-card_id="' + temp['1'] + '" href="#/board/' + board_id + '/card/' + temp['1'] + '">' + val + '</a>';
                text = text.replace(val, cardLink);
            }
        });
        return text;
    } else {
        var split_text = text.split(" ");
        var ret_text = '';
        if (split_text[0].match(/^@/)) {
            for (var i = 0; i < split_text.length; i++) {
                if (i === 0) {
                    ret_text += '<span class="atMention">' + split_text[0] + '</span>' + " ";
                } else {
                    ret_text += " " + split_text[i];
                }
            }
        } else {
            ret_text = text;
        }
        return ret_text;
    }
}

var favicon = new Favico({
    animation: 'popFade'
});

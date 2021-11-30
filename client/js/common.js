$(window).resize(function() {
    var headerH = $("header").height();
    var footerH = $("footer").height();
    var windowH = $(window).height();
    var notificationH = windowH - footerH;
    var boardH;
    if (footerH) {
        boardH = windowH - headerH - footerH - 14;
    } else {
        boardH = windowH - headerH - 50;
    }
    $(".board-list-view").css("height", (boardH + 'px'));
    if ($(".js-board-list") && (/Edge/.test(navigator.userAgent) || !!navigator.userAgent.match(/Trident.*rv\:11\./))) {
        $(".js-board-list").css("height", (boardH + 'px'));
    }
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
    hljs.initHighlightingOnLoad();
    $dc.on('click', ".dropdown-toggle:not([data-toggle='dropdown'])", function(e) {
        $('.dropdown').removeClass('open');
        $(this).parent().toggleClass('open');
    });
    $('body').on('click', function(e) {
        if (!$('.dropdown').is(e.target) && $('.dropdown').has(e.target).length === 0 && $('.open').has(e.target).length === 0) {
            $('.dropdown').removeClass('open');
        }
    });
    $dc.on('click', '.dropdown-menu:not(.modal-body .dropdown-menu)', function(e) {
        if ($(e.target).attr('data-toggle') !== 'modal') {
            e.stopPropagation();
        }
    });
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
    }).on('click', '.js-switch-board-view', function(e) {
        if (!_.isEmpty($(this).data('board-viewtype')) && !_.isUndefined($(this).data('board-viewtype'))) {
            if ($('#content #boards-view-' + $(this).data('board-viewtype')).length === 0) {
                if (!_.isUndefined(App.current_board) && !_.isEmpty(App.current_board) && App.current_board !== null && !App.current_board.attributes.is_closed) {
                    $('#content .js-boards-view').remove('');
                    view_type_tab = "task";
                    $('#content').html('<section id="boards-view-' + $(this).data('board-viewtype') + '" class="clearfix js-boards-view col-xs-12"><div class="cssloader"></div></section>');
                }
            }
        }
        return false;
    }).on('click', 'body', function(e) {
        if (!$('.js-open-dropdown .js-change-visibility').is(e.target) &&
            $('.js-open-dropdown .js-change-visibility').has(e.target).length === 0 &&
            $('.open').has(e.target).length === 0
        ) {
            $('.js-open-dropdown').removeClass('open');
        }
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

    $.fn.getCursorPosition = function() {
        var el = $(this).get(0);
        var pos = 0;
        var posEnd = 0;
        if ('selectionStart' in el) {
            pos = el.selectionStart;
            posEnd = el.selectionEnd;
        } else if ('selection' in document) {
            el.focus();
            var Sel = document.selection.createRange();
            var SelLength = document.selection.createRange().text.length;
            Sel.moveStart('character', -el.value.length);
            pos = Sel.text.length - SelLength;
            posEnd = Sel.text.length;
        }
        return [pos, posEnd];
    };
})
(jQuery);

function changeTitle(title, Iscardview) {
    var title_format = (Iscardview === true) ? "%s | %s's Restyaboard" : "%s's Restyaboard | %s";
    var title_content = (Iscardview === true) ? [title, SITE_NAME] : [SITE_NAME, title];
    if (title !== undefined) {
        document.title = i18next.t(title_format, {
            postProcess: 'sprintf',
            sprintf: title_content
        });
    }
}

function appPageCallBack(e) {
    appManage(e);
}

function checkKeycode(keycode, c) {
    for (var b = 0, d = keycode.length; b < d; b++)
        if (b in keycode && keycode[b] === c) return b;
    return -1;
}

function makeLink(text, board_id) {
    text = text.replace(/#(\d+)/g, '<a class="js-open-card-view" data-card_id="$1" href="#/board/' + board_id + '/card/$1">#$1</a>');
    if (!_.isUndefined(APPS) && APPS !== null) {
        if (!_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
            if ($.inArray('r_wiki', APPS.enabled_apps) !== -1) {
                text = text.replace(/%(\d+)/g, '<a class="js-open-wiki-view" target="_blank" data-card_id="$1" href="#/apps/r_wiki/pages?id=$1">%$1</a>');
            }
        }
    }

    text = text.replace(/(?!\b)(@\w+\b)/g, '<span class="atMention">$1</span>');
    return text;
}

function CheckFieldExists(board, field_name, field_value, return_type, plugin_name) {
    var checked_value = (return_type === 'Value') ? field_value : true;
    if (!_.isUndefined(APPS) && APPS !== null) {
        if (!_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
            if ($.inArray(plugin_name, APPS.enabled_apps) !== -1) {
                if (!_.isUndefined(board) && !_.isEmpty(board) && !_.isUndefined(board.attributes) && !_.isEmpty(board.attributes) && !_.isUndefined(board.attributes.board_custom_fields) && !_.isEmpty(board.attributes.board_custom_fields)) {
                    board_custom_fields = JSON.parse(board.attributes.board_custom_fields);
                    if (!_.isUndefined(board_custom_fields[plugin_name])) {
                        r_gridview_configurations = board_custom_fields[plugin_name].split(',');
                        if (r_gridview_configurations.length > 0) {
                            if (r_gridview_configurations.indexOf(field_name) !== -1 || r_gridview_configurations.indexOf('selectall') !== -1) {
                                checked_value = (return_type === 'Value') ? field_value : true;
                            } else {
                                checked_value = (return_type === 'Value') ? '' : false;
                            }
                        } else {
                            checked_value = (return_type === 'Value') ? '' : false;
                        }
                    }
                }
            }
        }
    }
    return checked_value;
}

function CheckFieldPermission(board, board_user_role_id, permission) {
    var checked_permission = false;
    if (!_.isUndefined(authuser) && !_.isUndefined(authuser.user) && !_.isUndefined(board) && !_.isEmpty(board) && (authuser.user.role_id == 1 || (!_.isUndefined(board.acl_links) && !_.isEmpty(board.acl_links)))) {
        if (authuser.user.role_id == 1) {
            checked_permission = true;
        } else if (!_.isEmpty(board.acl_links.where({
                slug: permission,
                board_user_role_id: parseInt(board_user_role_id)
            }))) {
            checked_permission = true;
        }
    }
    return checked_permission;
}

function activityCommentReplace(activity) {
    if (!_.isUndefined(activity.comment) && !_.isEmpty(activity.comment)) {
        activity.comment = activity.comment.replace("the card ##CARD_LINK##", "this card");
    }
    return activity;
}
var favicon = new Favico({
    animation: 'popFade'
});

function parse_date(dateTime, logged_user, classname, isAbbrReturn) {
    var s = dateTime.replace("T", " "),
        current_timezone;
    new_date = moment.tz(s, 'YYYY-MM-DD HH:mm:ss', SITE_TIMEZONE).utc().format('YYYY-MM-DD HH:mm:ss');
    if (logged_user && logged_user.user && !_.isUndefined(logged_user.user.timezone) && !_.isEmpty(logged_user.user.timezone) && logged_user.user.timezone !== null) {
        current_timezone = moment.tz(logged_user.user.timezone).format('Z').replace(':', '');
    } else {
        current_timezone = moment.tz(SITE_TIMEZONE).format('Z').replace(':', '');
    }
    tz = moment(new_date + ' Z').utcOffset(current_timezone).format('YYYY-MM-DD HH:mm:ss');
    if (!moment.isMoment(tz)) {
        tz = moment(tz);
    }
    var timestr = '<abbr title="' + tz.format() + '">' + tz.fromNow() + '</abbr>';
    if (isAbbrReturn !== undefined) {
        return timestr;
    } else {
        $('.' + classname).html(timestr);
        return true;
    }
}




function stripScripts(s) {
    var div = document.createElement('div');
    div.innerHTML = s;
    var scripts = div.getElementsByTagName('script');
    var i = scripts.length;
    while (i--) {
        scripts[i].parentNode.removeChild(scripts[i]);
    }
    return div.innerHTML;
}

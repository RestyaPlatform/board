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
        if ($('.js-open-dropdown .js-change-visibility').has(e.target).length === 0 && !$('.js-open-dropdown .js-change-visibility').is(e.target) && $('.open').has(e.target).length === 0 ) {
            $('.js-open-dropdown').removeClass('open');
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
            if ($('#content #boards-view-' + $(this).data('board-viewtype')).length === 0 && !_.isUndefined(App.current_board) && !_.isEmpty(App.current_board) && App.current_board !== null && !App.current_board.attributes.is_closed) {
                $('#content .js-boards-view').remove('');
                view_type_tab = "task";
                $('#content').html('<section id="boards-view-' + $(this).data('board-viewtype') + '" class="clearfix js-boards-view col-xs-12"><div class="cssloader"></div></section>');
            }
        }
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
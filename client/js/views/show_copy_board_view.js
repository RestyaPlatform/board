/**
 * @fileOverview This file has functions related to show all visibility view. This view calling from board add view, board header view and board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: visibility(String).
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ShowCopyBoard View
 * @class ShowCopyBoardView
 * @constructor
 * @extends Backbone.View
 */
App.ShowCopyBoardView = Backbone.View.extend({
    tagName: 'li',
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/show_copy_board'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit #BoardCopyForm': 'copyNewBoard',
        'click .js-keep_card_trigger': 'KeepCardTrigger',
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board: this.model,
        }));
        $('.js-filter-parent').addClass('open');
        this.showTooltip();
        return this;
    },
    /**
     * KeepCardTrigger()
     * enable/disable all the card option
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    KeepCardTrigger: function(e) {
        var keepCards = this.$el.find('input[name="keepCards"]:checked').length > 0;
        $('.js-keep_card_enable').each(function() {
            $(this).prop("checked", keepCards);
            if (keepCards) {
                $(this).removeAttr("disabled");
            } else {
                $(this).attr("disabled", true);
            }
        });
    },
    /**
     * copyBoard()
     * copy the exisiting board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    copyNewBoard: function(e) {
        $('#submitBoardCopy').attr('disabled', 'disabled');
        if (!$.trim($('#inputCopyBoardName').val()).length) {
            $('.error-msg').remove();
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputCopyBoardName');
        } else {
            $('.error-msg').remove();
            e.preventDefault();
            var self = this;
            var data = $(e.target).serializeObject();
            var keepUsers = self.$el.find('input[name="keepUsers"]:checked').length > 0;
            if (keepUsers) {
                data.keepUsers = "1";
            }
            data.user_id = authuser.user.id;
            var board = new App.Board();
            board.url = api_url + 'boards/' + this.model.id + '/copy.json';
            $('.js-back-to-sidebar').trigger('click');
            board.save(data, {
                success: function(model, response) {
                    if (!_.isUndefined(board.get('id'))) {
                        app.navigate('#/board/' + board.get('id'), {
                            trigger: true,
                            replace: true,
                        });
                        location.reload();
                        self.flash('success', i18next.t('Board copied successfully.'));
                    } else {
                        self.flash('danger', i18next.t('Unable to copy the board.'));
                    }
                    $('#submitBoardCopy').removeAttr("disabled");
                }
            });
        }
        return false;
    },
});

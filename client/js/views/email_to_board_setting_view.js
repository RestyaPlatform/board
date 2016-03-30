/**
 * @fileOverview This file has functions related to archived items view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model and it's related values. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Email To Board Setting View
 * @class EmailToBoardSettingView
 * @constructor
 * @extends Backbone.View
 */
App.EmailToBoardSettingView = Backbone.View.extend({
    tagName: 'li',
    template: JST['templates/email_to_board_setting'],
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
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'change .js-select-list, .js-select-position': 'updateDefaultEmailDetail',
        'click .js-select-list, .js-select-position, .js-board-email': 'updateDefaultEmailDetail',
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var imap_email = IMAP_EMAIL.split('@');
        var board_email = imap_email[0] + '+' + this.model.id + '+' + calcMD5(SecuritySalt + this.model.id) + '@' + imap_email[1];
        this.$el.html(this.template({
            board: this.model,
            board_email: board_email
        }));
        this.showTooltip();
        return this;
    },
    updateDefaultEmailDetail: function(e) {
        var data = {};
        if ($(e.currentTarget).hasClass('js-select-list')) {
            data = {
                default_email_list_id: $(e.currentTarget).val()
            };
        } else if ($(e.currentTarget).hasClass('js-select-position')) {
            data = {
                is_default_email_position_as_bottom: $(e.currentTarget).val()
            };
        }
        if (!_.isEmpty(data)) {
            var board = new App.Board();
            this.model.set(data);
            App.boards.get(this.model.attributes.id).set(data);
            board.set(data);
            board.set('id', this.model.id);
            board.url = api_url + 'boards/' + this.model.id + '.json';
            board.save(data, {
                patch: true
            });
        }
        return false;
    }
});

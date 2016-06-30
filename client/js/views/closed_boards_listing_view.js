/**
 * @fileOverview This file has functions related to closed boardsL listing view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board item model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ShowAllVisibility View
 * @class ShowAllVisibilityView
 * @constructor
 * @extends Backbone.View
 */
App.ClosedBoardsListingView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.authuser = options.authuser;
        this.render();
    },
    template: JST['templates/closed_boards_listing'],
    tagName: 'li',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-reopen-dropdown': 'openDropdown',
        'click .js-board-reopen': 'reopenBoard'
    },

    /**
     * reopenBoard()
     * reopen closed the board
     * @return false
     *
     */
    reopenBoard: function(e) {
        var board = new App.Board();
        board.url = api_url + 'boards/' + this.model.id + '.json';
        board.set('id', this.model.id);
        App.boards.get(this.model.id).set('is_closed', 0);
        board.save({
            is_closed: 0
        }, {
            success: function(model, response) {
                app.navigate('#/board/' + board.get('id'), {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * openDropdown()
     * copy the existing card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    openDropdown: function(e) {
        e.preventDefault();
        $(e.currentTarget).addClass('open');
        return false;
    },
    /**
     * boardRename()
     * close the dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        $('.js-reopen-dropdown').removeClass('open');
        return false;
    },
    render: function() {
        this.$el.html(this.template({
            board: this.model
        }));
        this.showTooltip();
        return this;
    }
});

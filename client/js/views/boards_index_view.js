/**
 * @fileOverview This file has functions related to board index view. This view calling from apllication view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardsIndex View
 * @class BoardsIndexView
 * @constructor
 * @extends Backbone.View
 */
App.BoardsIndexView = Backbone.View.extend({
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
    template: JST['templates/board_index'],
    tagName: 'section',
    className: 'clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-board': 'deleteBoard',
    },
    /**
     * deleteBoard()
     * delete board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    deleteBoard: function(e) {
        if (confirm($(e.currentTarget).data('confirm'))) {
            var dataUrl = $(e.currentTarget).attr('href');

            var board = new App.Board();
            board.url = api_url + dataUrl + '.json';
            board.set('id', '-1');
            board.destroy({
                success: function() {
                    Backbone.history.loadUrl();
                }
            });
        }
        return false;
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
            'board': this.model
        }));
        this.showTooltip();
        return this;
    }
});

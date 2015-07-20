/**
 * @fileOverview This file has functions related to show all visibility view. This view calling from board add view, board header view and board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: visibility(String).
 */
if (typeof App == 'undefined') {
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
        'submit #BoardCopyForm': 'copyNewBoard'
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
     * copyBoard()
     * copy the exisiting board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    copyNewBoard: function(e) {
        e.preventDefault();
        $('#submitBoardCopy', $(e.target)).attr('disabled', true);
        var data = $(e.target).serializeObject();
        data.user_id = authuser.user.id;
        var board = new App.Board();
        board.url = api_url + 'boards/' + this.model.id + '/copy.json';
        board.save(data, {
            success: function(model, response) {
                app.navigate('#/board/' + board.get('id'), {
                    trigger: true,
                    replace: true,
                });
            }
        });
        return false;
    },
});

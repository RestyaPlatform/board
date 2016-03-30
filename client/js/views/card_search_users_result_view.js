/**
 * @fileOverview This file has functions related to card search user list view. This view calling from instanr card add view and modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardSearchUsersResult View
 * @class CardSearchUsersResultView
 * @constructor
 * @extends Backbone.View
 */
App.CardSearchUsersResultView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.is_added_user = options.is_added_user;
        this.added_user = options.added_user;
        this.board = options.board;
        this.render();
    },
    template: JST['templates/card_search_users_result'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            user: this.model,
            is_added_user: this.is_added_user,
            added_user: this.added_user,
            board: this.board
        });
        this.showTooltip();
        return this;
    }
});

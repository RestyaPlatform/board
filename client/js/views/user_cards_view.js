/**
 * @fileOverview This file has functions related to user cards view. This view calling from user view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * UserCards View
 * @class UserCardsView
 * @constructor
 * @extends Backbone.View
 */
App.UserCardsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.key = options.key;
        this.render();
    },
    template: JST['templates/user_cards'],
    tagName: 'section',
    className: 'clearfix',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card_user: this.model,
            key: this.key
        }));
        this.showTooltip();
        return this;
    }
});

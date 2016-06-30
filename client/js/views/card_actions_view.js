/**
 * @fileOverview This file has functions related to card action view. This view calling from card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardActions View
 * @class CardActionsView
 * @constructor
 * @extends Backbone.View
 */
App.CardActionsView = Backbone.View.extend({
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
    template: JST['templates/card_actions'],
    tagName: 'ul',
    className: 'dropdown-menu dropdown-menu-right arrow arrow-right js-card-action-list-response',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card: this.model
        }));
        this.showTooltip();
        return this;
    }
});

/**
 * @fileOverview This file has functions related to card position form view. This view calling from card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. It contain all card based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardLabelsForm View
 * @class CardPositionsFormView
 * @constructor
 * @extends Backbone.View
 */
App.CardPositionsFormView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.boards = options.boards;
        this.render();
    },
    template: JST['templates/card_positions_form'],
    tagName: 'li',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card: this.model,
            boards: this.boards
        }));
        this.showTooltip();
        return this;
    }
});

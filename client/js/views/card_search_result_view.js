/**
 * @fileOverview This file has functions related to card search view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. It contain all board based object @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardSearchResult View
 * @class CardSearchResultView
 * @constructor
 * @extends Backbone.View
 */
App.CardSearchResultView = Backbone.View.extend({
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
    template: JST['templates/card_search_result'],
    tagName: 'li',
    className: 'js-select-card',
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

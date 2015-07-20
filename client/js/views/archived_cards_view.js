/**
 * @fileOverview This file has functions related to archived cards view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model and it's related values. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * ArchivedCards View
 * @class ArchivedCards
 * @constructor
 * @extends Backbone.View
 */
App.ArchivedCardsView = Backbone.View.extend({
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
    template: JST['templates/archived_cards'],
    tagName: 'div',
    className: 'clearfix col-xs-12',
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
        this.showTooltip();
        return this;
    }
});

/**
 * @fileOverview This file has functions related to card copy view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model. @see Available Object in ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardCopy View
 * @class CardCopyView
 * @constructor
 * @extends Backbone.View
 */
App.CardCopyView = Backbone.View.extend({
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
    template: JST['templates/card_copy'],
    tagName: 'ul',
    className: 'dropdown-menu dropdown-menu-right arrow arrow-right js-card-action-list-response js-dropdown-popup',
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

/**
 * @fileOverview This file has functions related to select board visibility view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ArchivedCard View
 * @class ArchivedCardView
 * @constructor
 * @extends Backbone.View
 */
App.SelectBoardVisibilityView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.data = options.data;
        this.render();
    },
    template: JST['templates/select_board_visibility'],
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            name: this.model,
            data: this.data
        }));
        this.showTooltip();
        return this;
    }
});

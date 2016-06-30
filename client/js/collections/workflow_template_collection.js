if (typeof App === 'undefined') {
    App = {};
}
/**
 * WorkFlow Template Collection
 * @class WorkFlowTemplateCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.WorkFlowTemplateCollection = Backbone.Collection.extend({
    model: App.WorkFlowTemplate
});

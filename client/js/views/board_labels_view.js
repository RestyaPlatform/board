App.BoardLabelsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            if (!_.isUndefined(authuser.user) && !_.isUndefined(this.model.board_users)) {
                var board_user_role_id = this.model.board_users.findWhere({
                    user_id: parseInt(authuser.user.id)
                });
                if (!_.isEmpty(board_user_role_id)) {
                    this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
                }
            }
        }
        this.labels = options.labels;
        this.render();
    },
    template: JST['templates/board_labels'],
    tagName: 'li',
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    /** 
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-labels': 'deleteLabels',
        'click .js-show-edit-card-label-form': 'showCardLabelEditForm',
        'click .js-card-label-color-pick': 'colorPicker',
        'click .js-hide-edit-card-label-form': 'hideCardLabelEditForm',
        'click .js-show-card-label-colorpicker': 'showCardLabelColorpicker',
        'keyup .js-search-board-labels': 'showFilteredLabels'
    },
    deleteLabels: function(e) {
        var label_id = $(e.currentTarget).data('id');
        $('.js-setting-response').html(new App.LabelDeleteConfirmView({
            model: this.model,
            label_id: label_id
        }).el);
        return false;
    },
    /**
     * showCardLabelEditForm()
     * display card label edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showCardLabelEditForm: function(e) {
        var self = this;
        $('.js-side-bar-' + this.model.id).addClass('side-bar-large');
        this.model.labels.setSortField('name', 'asc');
        this.model.labels.sort();
        var label_id = $(e.currentTarget).data('id');
        var label = this.labels.findWhere({
            'board_id': self.model.id,
            'label_id': label_id
        });
        $('.js-setting-response').html(new App.BoardLabelsEditView({
            model: this.model,
            label: label
        }).el);
        var headerH = $('header').height();
        var windowH = $(window).height();
        var footerH = $('footer').height();
        var boardH = windowH - headerH - footerH - 14;
        $('.member-modal.js-pre-scrollable').css({
            'max-height': boardH - 50,
            'overflow-y': 'auto'
        });
        return false;
    },
    /**
     * FilterCardLabels()
     * filter card label
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showFilteredLabels: function(e) {
        e.preventDefault();
        var self = this;
        this.$el.find('.js-board-labels-container').html('');
        var search_value = $(e.currentTarget).val();
        var filteredLabels;
        filteredLabels = this.model.labels.filter(function(label) {
            if(label.attributes.name.toUpperCase().indexOf(search_value.toUpperCase()) != -1) {
                return label;
            }
        });
        if (!_.isEmpty(filteredLabels) && !_.isUndefined(filteredLabels)) {
            var string = '';
            var labels = Array();
            if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(self.model.acl_links.where({
                    slug: "edit_labels",
                    board_user_role_id: parseInt(self.model.board_user_role_id)
                })))) {
                editLabel = 'js-show-edit-card-label-form cur';
            }
            _.each(filteredLabels, function(label) {
                if (!_.contains(labels, label.attributes.name)) {
                    labels.push(label.attributes.name);
                    var labelColor = (label.attributes.color) ? label.attributes.color : '#' + self.converter.colorCode(label.attributes.name).substring(0, 6);
                    string += '<li class="clearfix cur card-label-show h5 btn-link media"><div data-id="' + label.attributes.label_id + '" class="' + editLabel + '"><span style="background:' + labelColor + ';color:#ffffff" class="pull-left btn btn-xs"><i class="' + LABEL_ICON + ' icon-light cur"></i></span><div class="board-labels"><div class="htruncate"> ' + label.attributes.name + '</div></div><div class="js-delete-labels-icon pull-right"><a data-id="' + label.attributes.label_id + '" class="js-delete-labels btn btn-default btn-xs pull-right" data-toggle="dropdown"><i class="icon-remove cur"></i></a></div></li>';
                }
            });
            self.$el.find('.js-board-labels-container').append(string);
        }
        return false;
    },
    /**
     * hideCardLabelEditForm()
     * hide the card label edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    hideCardLabelEditForm: function(e) {
        e.preventDefault();
        $(e.currentTarget).parents('form').addClass('hide').prev('.js-show-edit-card-label-form').removeClass('hide');
        $(e.currentTarget).closest('li').find('.js-delete-labels-icon').removeClass('hide');
        return false;
    },
    /**
     * colorPicker()
     * add selected card in lis
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    colorPicker: function(e) {
        var self = this;
        var color = $(e.target).closest('li').data('color');
        var label_id = $(e.target).closest('ul').data('label_id');
        var data = {
            color: color,
            id: label_id
        };
        self.model.url = api_url + 'labels/' + label_id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {
                self.model.labels.findWhere({
                    label_id: parseInt(label_id)
                }).set('color', color);
            }
        });
        return false;
    },
    /**
     * showCardLabelColorpicker()
     * show card label colorpicker form
     * @param e
     * @type Object(DOM event)
     */
    showCardLabelColorpicker: function(e) {
        e.preventDefault();
        var target = $(e.target);
        $('li.dropdown').removeClass('open');
        target.parents('div.dropdown').addClass('open');
        return false;
    },
    /**   
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object 
     *
     */
    render: function() {
        this.converter.setFlavor('github');
        this.$el.html(this.template({
            board: this.model,
            board_labels: this.labels,
            converter: this.converter
        }));
        this.showTooltip();
        return this;
    }
});

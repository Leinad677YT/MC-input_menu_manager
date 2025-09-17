data modify storage l.menu:triggers 123 set value {\
                                    list_t:[\
                                        {\
                                            trigger: "jump",\
                                            predicate: "test:jump" \
                                        },\
                                        {\
                                            trigger: "left",\
                                            predicate: "test:left" \
                                        },\
                                        {\
                                            trigger: "right",\
                                            predicate: "test:right" \
                                        },\
                                        {\
                                            trigger: "forward",\
                                            predicate: "test:forward" \
                                        },\
                                        {\
                                            trigger: "backward",\
                                            predicate: "test:backward" \
                                        }\
                                    ]\
}

data modify storage l.menu:123 0 set value {\
                                    t_jump: {\
                                        function: "example_menu:say {say:\"jump\"}", \
                                        main: 123, \
                                        secondary: 1\
                                    },\
                                    t_left: {\
                                        function: "example_menu:say {say:\"left\"}" \
                                    },\
                                    t_right: {\
                                        function: "example_menu:say {say:\"right\"}" \
                                    },\
                                    t_forward: {\
                                        function: "example_menu:say {say:\"forward\"}" \
                                    },\
                                    t_backward: {\
                                        function: "example_menu:say {say:\"backward\"}" \
                                    },\
                                    d_list:[{display:"ijump"}],\
                                    d_ijump: {item:{id:"minecraft:coal"}}\
}

data modify storage l.menu:123 1 set value {\
                                    t_jump: {\
                                        function: "example_menu:say {say:\"jump\"}", \
                                        main: 123, \
                                        secondary: 0\
                                    },\
                                    d_list:[{display:"ijump"}],\
                                    d_ijump: {item:{id:"minecraft:diamond"}}\
}
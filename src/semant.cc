/*
Copyright (c) 1995,1996 The Regents of the University of California.
All rights reserved.

Permission to use, copy, modify, and distribute this software for any
purpose, without fee, and without written agreement is hereby granted,
provided that the above copyright notice and the following two
paragraphs appear in all copies of this software.

IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

Copyright 2017-2019 Michael Linderman.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

#include <algorithm>
#include <cstdlib>
#include <fmt/ostream.h>
#include <spdlog/spdlog.h>

#include "ast.h"
#include "semant.h"
#include "utilities.h"

namespace cool {

// clang-format off
/**
   * @name Predefined symbols used in Cool
   *
   * extern indicates that these variables are defined elsewhere (in this case ast_consumer.cc)
   * and so C++ doesn't need to create any storage.
   *
   * @{
   */
extern Symbol
    *arg,
    *arg2,
    *Bool,
    *concat,
    *cool_abort,
    *copy,
    *Int,
    *in_int,
    *in_string,
    *IO,
    *isProto,
    *length,
    *Main,
    *main_meth,
    *No_class,
    *No_type,
    *Object,
    *out_int,
    *out_string,
    *prim_slot,
    *self,
    *SELF_TYPE,
    *String,
    *str_field,
    *substr,
    *type_name,
    *val;
//@}
// clang-format on

std::ostream& SemantError::operator()(const SemantNode* node) { return (*this)(node->klass()); }


SemantKlassTable::SemantKlassTable(SemantError& error, Klasses* klasses)
    : KlassTable(), error_(error) {

    // Pass 1, Part 1: Build inheritance graph
    // printf("the size of klassTable = %d\n", klasses->size());
    if (error_.errors() > 0) return;  // Can't continue with class table construction if errors found


    // Pass 1, Part 2: Check for cycles in inheritance graph
}


void Semant(Program* program) {
    // Get something on the screen first
    Klasses * listOfClasses = program->klasses();
    for (Klass * c : *(listOfClasses)) {
        std::cout << "name:" << c->name()->value() <<
                     ", parent: " << c->parent()->value() << std::endl;
    }
    // std::cout << "class count: " << listOfClasses::size; 
    std::cout << "---------------------------" << std::endl;

    // Initialize error tracker (and reporter)
    SemantError error(std::cerr);

    // Perform semantic analysis...

    // Halt program with non-zero exit if there are semantic errors
    if (error.errors()) {
        std::cerr << "Compilation halted due to static semantic errors." << std::endl;
        exit(1);
    }
}

}  // namespace cool
